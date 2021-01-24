package com.applet.netty;

import com.alibaba.fastjson.JSONObject;
import com.applet.chat.ChatRecordSaveTask;
import com.applet.thread.ThreadPoolManager;
import com.applet.utils.SpringContextHelper;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelFutureListener;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.SimpleChannelInboundHandler;
import io.netty.handler.codec.http.*;
import io.netty.handler.codec.http.websocketx.*;
import io.netty.util.AttributeKey;
import io.netty.util.CharsetUtil;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

import java.util.List;
import java.util.Map;

/**
 * Created by Jackie Liu on 2017/7/11.
 */
public class WebSocketServerHandler extends SimpleChannelInboundHandler<Object> {

    private static final Logger logger = Logger.getLogger(WebSocketServerHandler.class);

    private WebSocketServerHandshaker handshaker;
    private String webSocketUrl;

    private ChannelManager manager = new ChannelManager();

    public WebSocketServerHandler(String webSocketUrl) {
        this.webSocketUrl = webSocketUrl;
    }

    /**
     * channel 通道 action 活跃的 当客户端主动链接服务端的链接后，这个通道就是活跃的了。也就是客户端与服务端建立了通信通道并且可以传输数据
     */
    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {
        // 添加
        //Global.group.add(ctx.channel());
        logger.info("客户端与服务端连接开启：" + ctx.channel());
    }

    /**
     * channel 通道 Inactive 不活跃的 当客户端主动断开服务端的链接后，这个通道就是不活跃的。也就是说客户端与服务端关闭了通信通道并且不可以传输数据
     */
    @Override
    public void channelInactive(ChannelHandlerContext ctx) throws Exception {
        //发送消息，通知房间内所有用户该设备离线
        String deviceId = ctx.attr(AttributeKey.<String>valueOf("deviceId")).get();
        String roomId = ctx.attr(AttributeKey.<String>valueOf("roomId")).get();
        String msg = String.format("{\"type\":\"offline\", \"msg\":\"%s\"}", deviceId);
        manager.send(roomId, msg);

        // 移除
        manager.remove(ctx);
        logger.info("客户端与服务端连接关闭：" + ctx.channel());
    }

    /**
     * 接收客户端发送的消息 channel 通道 Read 读 简而言之就是从通道中读取数据，也就是服务端接收客户端发来的数据。但是这个数据在不进行解码时它是ByteBuf类型的
     */
    @Override
    protected void messageReceived(ChannelHandlerContext ctx, Object msg) throws Exception {
        // 传统的HTTP接入
        if (msg instanceof FullHttpRequest) {
            handleHttpRequest(ctx, ((FullHttpRequest) msg));
        } else if (msg instanceof WebSocketFrame) {// WebSocket接入
            handlerWebSocketFrame(ctx, (WebSocketFrame) msg);
        }
    }

    /**
     * channelRead channel 通道 Read 读 简而言之就是从通道中读取数据，也就是服务端接收客户端发来的数据
     * 但是这个数据在不进行解码时它是ByteBuf类型
     */
    /*@Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
        super.channelRead(ctx, msg);
    }*/

    /**
     * channel 通道 Read 读取 Complete 完成 在通道读取完成后会在这个方法里通知，对应可以做刷新操作 ctx.flush()
     */
    @Override
    public void channelReadComplete(ChannelHandlerContext ctx) throws Exception {
        ctx.flush();
    }

    private void handlerWebSocketFrame(ChannelHandlerContext ctx, WebSocketFrame frame) {
        // 判断是否关闭链路的指令
        if (frame instanceof CloseWebSocketFrame) {
            handshaker.close(ctx.channel(), (CloseWebSocketFrame) frame.retain());
            return;
        }
        // 判断是否ping消息
        if (frame instanceof PingWebSocketFrame) {
            ctx.channel().write(new PongWebSocketFrame(frame.content().retain()));
            return;
        }
        // 本例程仅支持文本消息，不支持二进制消息
        if (!(frame instanceof TextWebSocketFrame)) {
            logger.info("本例程仅支持文本消息，不支持二进制消息");
            throw new UnsupportedOperationException(
                    String.format("%s frame types not supported", frame.getClass().getName()));
        }
        // 返回应答消息
        String request = ((TextWebSocketFrame) frame).text();
        if (logger.isDebugEnabled()) {
            logger.debug(String.format("%s received message : %s", ctx.channel(), request));
        }
        if ("_h_k_".equals(request)) {
            ctx.writeAndFlush(new TextWebSocketFrame("_h_k_"));
            return;
        }

        JSONObject json = JSONObject.parseObject(request);
        String roomId = json.getString("roomId");
        String deviceIdsStr = json.getString("deviceIds");
        String type = json.getString("type");
        String[] deviceIds = StringUtils.isBlank(deviceIdsStr) ? null : deviceIdsStr.split(",");

        json.remove("deviceIds");
        json.remove("roomId");

        String msg = json.toString();
        manager.send(roomId, deviceIds, msg);
        //ctx.flush();

        saveChartRecord(roomId, type, msg);
    }

    private void saveChartRecord(String roomId, String type, String msg) {
        if (!"im".equals(type)) {
            return;
        }

        ChatRecordSaveTask chatRecordSaveTask = new ChatRecordSaveTask(roomId, msg);
        ThreadPoolManager manager = SpringContextHelper.getBean(ThreadPoolManager.class);
        manager.executeTask(chatRecordSaveTask);
    }

    private void handleHttpRequest(ChannelHandlerContext ctx, FullHttpRequest req) {
        // 如果HTTP解码失败，返回HHTP异常
        if (!req.getDecoderResult().isSuccess() || (!"websocket".equals(req.headers().get("Upgrade")))) {
            sendHttpResponse(ctx, req, new DefaultFullHttpResponse(HttpVersion.HTTP_1_1, HttpResponseStatus.BAD_REQUEST));
            return;
        }

        // 构造握手响应返回，本机测试
        WebSocketServerHandshakerFactory wsFactory = new WebSocketServerHandshakerFactory(webSocketUrl, null, false);
        handshaker = wsFactory.newHandshaker(req);
        if (handshaker == null) {//版本不支持
            WebSocketServerHandshakerFactory.sendUnsupportedWebSocketVersionResponse(ctx.channel());
            return;
        }

        ChannelFuture channelFuture = handshaker.handshake(ctx.channel(), req);
        if (!channelFuture.isSuccess()) {
            return;
        }

        //握手成功之后，获取url后置参数
        String uri = req.getUri();
        QueryStringDecoder queryStringDecoder = new QueryStringDecoder(uri);
        Map<String, List<String>> parameters = queryStringDecoder.parameters();
        List<String> roomIdList = parameters.get("roomId");
        List<String> deviceIdList = parameters.get("deviceId");
        if (CollectionUtils.isEmpty(roomIdList) || CollectionUtils.isEmpty(deviceIdList)) {
            TextWebSocketFrame tws = new TextWebSocketFrame("{msg:'deviceId 或者 roomId 参数为空'}");
            ctx.writeAndFlush(tws);
            ctx.close();
            return;
        }

        String roomId = roomIdList.get(0);
        String deviceId = deviceIdList.get(0);

        //发送消息，通知房间内所有用户该设备上线
        String msg = String.format("{\"type\":\"online\", \"msg\":\"%s\"}", deviceId);
        manager.send(roomId, msg);

        //缓存会话
        manager.addChannel(roomId, deviceId, ctx);
    }

    private static void sendHttpResponse(ChannelHandlerContext ctx, FullHttpRequest req, DefaultFullHttpResponse res) {
        // 返回应答给客户端
        if (res.getStatus().code() != 200) {
            ByteBuf buf = Unpooled.copiedBuffer(res.getStatus().toString(), CharsetUtil.UTF_8);
            res.content().writeBytes(buf);
            buf.release();
        }
        // 如果是非Keep-Alive，关闭连接
        ChannelFuture f = ctx.channel().writeAndFlush(res);
        if (!HttpHeaders.isKeepAlive(req) || res.getStatus().code() != 200) {
            f.addListener(ChannelFutureListener.CLOSE);
        }
    }

    /**
     * exception 异常 Caught 抓住 抓住异常，当发生异常的时候，可以做一些相应的处理，比如打印日志、关闭链接
     */
    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        logger.error("", cause);
        ctx.close();
    }
}

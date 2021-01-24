package com.applet.netty;

import com.applet.push.PushMessage;
import com.applet.utils.FastJsonUtils;
import org.apache.log4j.Logger;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.data.redis.core.StringRedisTemplate;

/**
 * 推送消息订阅端
 * Created by Jackie Liu on 2017/9/1.
 */
public class PushSubscriber implements MessageListener {

    private Logger log = Logger.getLogger(PushSubscriber.class);

    private StringRedisTemplate redisTemplate;

    @Override
    public void onMessage(Message message, byte[] bytes) {
        byte[] body = message.getBody();//请使用valueSerializer
        //byte[] channel = message.getChannel();
        //请参考配置文件，本例中key，value的序列化方式均为string。
        //其中key必须为stringSerializer。和redisTemplate.convertAndSend对应
        String itemValue = (String) redisTemplate.getValueSerializer().deserialize(body);
        //String topic = (String) redisTemplate.getStringSerializer().deserialize(channel);
        //log.info("topic = "+ topic + "; itemValue = " + itemValue);
        PushMessage pushMessage = FastJsonUtils.jsonToObj(itemValue, PushMessage.class);
        String[] deviceIds = pushMessage.getDeviceIds();
        String msg = (String) pushMessage.getMessage();
        for (String deviceId : deviceIds) {
            new ChannelManager().send(deviceId, msg);
        }
    }

    public StringRedisTemplate getRedisTemplate() {
        return redisTemplate;
    }

    public void setRedisTemplate(StringRedisTemplate redisTemplate) {
        this.redisTemplate = redisTemplate;
    }
}

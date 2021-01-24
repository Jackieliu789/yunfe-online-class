package com.applet.netty;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.InitializingBean;

/**
 * Created by Jackie Liu on 2017/7/11.
 */
public class WebAsyncSocketServer implements InitializingBean {

    private static final Logger log = Logger.getLogger(WebAsyncSocketServer.class);

    private int bindPort;
    private String webSocketUrl = "ws://0.0.0.0:8488/yunfeisocket";

    public int getBindPort() {
        return bindPort;
    }

    public void setBindPort(int bindPort) {
        this.bindPort = bindPort;
    }

    public String getWebSocketUrl() {
        return webSocketUrl;
    }

    public void setWebSocketUrl(String webSocketUrl) {
        this.webSocketUrl = webSocketUrl;
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    WebSocketServer server = new WebSocketServer();
                    server.setPort(bindPort);
                    server.setWebSocketUrl(webSocketUrl);
                    server.run();
                    log.info("WebSocket server is going to start...");
                } catch (Exception e) {
                    log.error("", e);
                }
            }
        });
        thread.setDaemon(true);
        thread.start();
    }

    /*public static void main(String[] args) throws Exception {
        int port = 8080;
        new WebSocketServer().run(port);
    }*/
}

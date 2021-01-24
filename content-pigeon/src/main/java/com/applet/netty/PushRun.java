package com.applet.netty;

import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Created by Jackie Liu on 2017/9/1.
 */
public class PushRun {

    public static void main(String[] args) {
        PushRun container = new PushRun();
        container.start();
    }

    public void start() {
        final ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("classpath*:applicationContext*.xml", "classpath*:META-INF/dubbo-*.xml");
        try {
            context.start();
            //int port = 8089;
            //new WebSocketServer().run(port);
            //Class<?> clazz = Class.forName(WebSocketServer.class.getName());
            WebSocketServer webSocketServer = context.getBean(WebSocketServer.class);
            //SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(webSocketServer);
            webSocketServer.run();

            /*Runtime.getRuntime().addShutdownHook(new Thread() {

                @Override
                public void run() {
                    context.stop();
                    context.close();
                }
            });

            CountDownLatch countDownLatch = new CountDownLatch(1);
            try {
                countDownLatch.await();
            } catch (Exception e) {
                e.printStackTrace();
            }*/
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            context.close();
        }
    }
}

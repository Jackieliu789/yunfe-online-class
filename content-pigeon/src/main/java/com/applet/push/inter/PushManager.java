package com.applet.push.inter;

/**
 * SpringStarter interface
 *
 * @author Jackie Liu
 * @date 2018/1/6
 */
public interface PushManager<T> {

    public void addChannel(String roomId, String deviceId, T ctx);

    public void remove(T ctx);

    public boolean send(String roomId, String message);

    public boolean send(String roomId, String[] deviceIds, String message);

}

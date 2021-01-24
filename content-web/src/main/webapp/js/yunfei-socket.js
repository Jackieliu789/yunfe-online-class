function RtmClient(params) {
    var that = this;

    this.url = params.url;
    this.rId = params.roomId;
    this.dId = params.deviceId;

    this.timeout = 30000;//30s
    this.timeoutObj;

    this.socket;
    this.events = {};

    this.init = function () {
        that.socket = new ReconnectingWebSocket(that.url + "?roomId=" + that.rId + "&deviceId=" + that.dId);

        //连接发生错误的回调方法
        that.socket.onerror = function () {
            $.message("Socket连接建立失败!");
            console.log("websocket.error");
        };

        //连接成功建立的回调方法
        that.socket.onopen = function (event) {
            console.log("Socket连接建立成功!");
            that.keepAlive();
        };

        //接收到消息的回调方法
        that.socket.onmessage = function (event) {
            var msg = event.data;
            console.log("socket receive message " + msg);
            if ("_h_k_" == msg) {
                return;
            }
            var data = eval('(' + msg + ')');
            that.events[data.type] && that.events[data.type](data);
        };

        //连接关闭的回调方法
        that.socket.onclose = function () {
            that.socket.close();
            console.log("websocket.onclose");
        };
        return that.socket;
    };

    this.keepAlive = function () {
        that.timeoutObj && window.clearInterval(this.timeoutObj);
        that.timeoutObj = setInterval(function () {
            if (that.socket.readyState != WebSocket.OPEN) {
                console.log("WebSocket is not open!!!!!!");
                return;
            }
            that.socket && that.socket.send("_h_k_");
        }, that.timeout);
    };

    this.on = function (eventName, method) {
        that.events[eventName] = method;
    };

    this.send = function (data) {
        if (!that.socket || that.socket.readyState != WebSocket.OPEN) {
            console.log("WebSocket is not open!!!!!!");
            return;
        }
        that.socket && that.socket.send(JSON.stringify(data));
    };

    this.leave = function () {
        that.socket.close();
    };

    this.reconnect = function () {
        return that.init();
    };
}

var YunfeiRTM = {
    createInstance:function (params) {
        var client = new RtmClient(params);
        client.init();
        return client;
    }
};
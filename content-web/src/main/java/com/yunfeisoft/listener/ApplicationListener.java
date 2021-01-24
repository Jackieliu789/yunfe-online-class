package com.yunfeisoft.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * 系统初始化监听器
 */
public class ApplicationListener implements ServletContextListener {

    @Override
    public void contextDestroyed(ServletContextEvent arg0) {
    }

    @Override
    public void contextInitialized(ServletContextEvent arg0) {
        // 获取全量的权限资源信息
        //ResourceService service = (ResourceService) SpringContextHelper.getBean(ResourceService.class);
        //Map<String, Object> params = new HashMap<String,Object>();
        //Page<Resource> page = service.queryPage(params);
        //arg0.getServletContext().setAttribute("application_resource", page.getData());
    }
}
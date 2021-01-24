package com.yunfeisoft.directive;

import com.yunfeisoft.model.User;
import com.yunfeisoft.utils.ApiUtils;
import freemarker.core.Environment;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;
import org.apache.commons.lang3.StringUtils;

import java.io.IOException;
import java.util.Map;

/**
 * AuthorityDirective class
 *
 * @author Jackie Liu
 * @date 2018/1/4
 */
public class AuthorityDirective implements TemplateDirectiveModel {

    @Override
    public void execute(Environment env, Map params, TemplateModel[] templateModels, TemplateDirectiveBody body) throws TemplateException, IOException {
        String code = String.valueOf(params.get("code"));
        User user = ApiUtils.getLoginUser();
        if (StringUtils.isBlank(code) || user == null) {
            return;
        }
        if (!user.hasAuthority(code)) {
            return;
        }

        if (body != null) {
            body.render(env.getOut());
        }

    }
}

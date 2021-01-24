$(document).ready(function () {
    //头部导航
    $('#firstMenuDiv').find('dl').mouseenter(function () {// 鼠标移入移出样式
            var tar = $(this).attr('tar');
            $('div[class="menu_second"]').hide();
            secondMenuShow($(this), $('#second_menu' + tar));
    });
    // 鼠标移入main主页面后隐藏2、3级菜单
    $('#mainDiv').mouseenter(function () {
            //鼠标移出
            $('div[class="menu_second"]').hide();
     });
    //隔行换色
    $(".gy_table tr").mouseover(function () { //如果鼠标移到class为stripe_tb的表格的tr上时，执行函数
        $(this).addClass("over");
    }).mouseout(function () { //给这行添加class值为over，并且当鼠标一出该行时执行函数
        $(this).removeClass("over");
    }) //移除该行的class
    $(".gy_table tr:even").addClass("alt"); //给class为stripe_tb的表格的偶数行添加class值为alt

    $(".table1 tr").mouseover(function () { //如果鼠标移到class为stripe_tb的表格的tr上时，执行函数
        $(this).addClass("over");
    }).mouseout(function () { //给这行添加class值为over，并且当鼠标一出该行时执行函数
        $(this).removeClass("over");
    }) //移除该行的class
    $(".table1 tr:even").addClass("alt"); //给class为stripe_tb的表格的偶数行添加class值为alt

    $(".table2 tr").mouseover(function () { //如果鼠标移到class为stripe_tb的表格的tr上时，执行函数
        $(this).addClass("over");
    }).mouseout(function () { //给这行添加class值为over，并且当鼠标一出该行时执行函数
        $(this).removeClass("over");
    }) //移除该行的class
    $(".table2 tr:even").addClass("alt"); //给class为stripe_tb的表格的偶数行添加class值为alt

    $(".qxfp li").mouseover(function () { //如果鼠标移到class为stripe_tb的表格的tr上时，执行函数
        $(this).addClass("over");
    }).mouseout(function () { //给这行添加class值为over，并且当鼠标一出该行时执行函数
        $(this).removeClass("over");
    }) //移除该行的class
    $(".qxfp li:even").addClass("alt"); //给class为stripe_tb的表格的偶数行添加class值为alt

    //select下拉选择
    $(".xiala").hover(function () {
        $(this).find(".xl_con").show();
    }, function () {
        $(this).find(".xl_con").hide();
    });
});

//展开收起
$(function () {
    $(".xsd_sq").click(function () {
        var divObj = $(this).parents(".gytop");//siblings同级元素,parent父级元
        var tt = $(divObj).find(".xsd_con");
        if ($(tt).is(":visible")) {
            $(this).removeClass("xsd_zk");
            $(tt).hide();
        } else {
            $(tt).hide();//全部隐藏
            $(this).addClass("xsd_zk");
            $(tt).show();//显示指定div
        }
    });
})

//二、三级菜单的展示和展示位置
function secondMenuShow(firstMenuElement, secondMenuDiv) {
    var firstMenuLeft = firstMenuElement.offset().left;
    var windowWidth = $(window).width();
    var secondMenuWidth = secondMenuDiv.width();
    var secondMenuTop = firstMenuElement.offset().top + firstMenuElement.height();
    var secondMenuLeft = firstMenuLeft;
    var secondMenuRight = firstMenuLeft + secondMenuWidth;
    if (secondMenuLeft < 0) {
        secondMenuLeft = 0;
    }
    if (secondMenuRight + 24 >= windowWidth) {
        secondMenuLeft = windowWidth - secondMenuWidth - 24;
        secondMenuRight = windowWidth - 24;
    }
    secondMenuDiv.css({
        top: secondMenuTop,
        left: secondMenuLeft,
        width: secondMenuWidth
    });

    secondMenuDiv.show();
}

//选项卡
function setTab(name, cursel, n) {
    for (i = 1; i <= n; i++) {
        var menu = document.getElementById(name + i);
        var con = document.getElementById("con_" + name + "_" + i);
        menu.className = i == cursel ? "hover" : "";
        con.style.display = i == cursel ? "block" : "none";
    }
}

//后台二级菜单展开收起效果
$(document).ready(function () {
    //$(".leftMenu #secondMenu:not(:first)").hide();
    $(".leftMenu li").click(function () {
        $(this).next(".secondMenu").slideToggle("slow").siblings(".secondMenu:visible").slideUp("slow");
    });
});
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace IICA.Models.Entidades
{
    public class SessionExpire : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            try
            {
                HttpContext ctx = HttpContext.Current;
                if (HttpContext.Current.Session["usuarioSesion"] == null)
                {
                    if (filterContext.RequestContext.HttpContext.Request.IsAjaxRequest())
                    {
                        string url = "IICA/Index";
                        filterContext.Result = new HttpStatusCodeResult((int)HtppStatusCode.SessionVencida, url);
                    }
                    else
                    {
                        //filterContext.Result = new RedirectResult("~/Sesion/Login");
                        filterContext.Result = new RedirectToRouteResult(
                            new RouteValueDictionary{
                            { "controller", "IICA" },
                            { "action", "Index" }
                            });
                    }
                    return;
                }
                base.OnActionExecuting(filterContext);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }

    public enum HtppStatusCode
    {
        SessionVencida = 460
    }
}
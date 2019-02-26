using IICA.Models.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace IICA.Controllers
{
    public class HomeController : Controller
    {
        [SessionExpire]
        public ActionResult Index()
        {
            return View();
        }

        [SessionExpire]
        public ActionResult _MenuLeft()
        {
            try
            {
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                if (usuarioSesion != null)
                    return PartialView(usuarioSesion);
                else
                    return RedirectToAction("Index","IICA");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
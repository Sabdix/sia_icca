using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace IICA.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult _MenuLeft()
        {
            try
            {
                return PartialView();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
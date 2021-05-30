using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Logging;

namespace disoftware.Pages
{
    public class MaquinasModel : PageModel
    {
        private readonly ILogger<MaquinasModel> _logger;

        public MaquinasModel(ILogger<MaquinasModel> logger)
        {
            _logger = logger;
        }

        public void OnGet()
        {
        }
    }
}

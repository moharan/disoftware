using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Logging;

namespace disoftware.Pages
{
    public class PrincipalModel : PageModel
    {
        private readonly ILogger<PrincipalModel> _logger;

        public PrincipalModel(ILogger<PrincipalModel> logger)
        {
            _logger = logger;
        }

        public void OnGet()
        {
        }
    }
}

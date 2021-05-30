using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Logging;

namespace disoftware.Pages
{
    public class UsuariosModel : PageModel
    {
        private readonly ILogger<UsuariosModel> _logger;

        public UsuariosModel(ILogger<UsuariosModel> logger)
        {
            _logger = logger;
        }

        public void OnGet()
        {
        }
    }
}

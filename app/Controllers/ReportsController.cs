using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace app.Controllers
{
    [Route("api/v1/reports")]
    [ApiController]
    public class ReportsController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();
        public ReportsController(EasyPublishingContext context)
        {
            _context = context;
        }

        [HttpGet("options")]
        public async Task<ActionResult> GetReportType()
        {
            var types = await _context.ReportTypes.Select(c => new { c.ReportTypeId, c.ReportTypeContent }).ToListAsync();
            return _msgService.MsgReturn(0, "Report Option", types);
        }
    }
}

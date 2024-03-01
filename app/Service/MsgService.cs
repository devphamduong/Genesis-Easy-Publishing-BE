using Microsoft.AspNetCore.Mvc;
using System.Drawing.Printing;

namespace app.Service
{
    public class MsgService
    {
        public JsonResult MsgPagingReturn(String msg, Object list, int page, int pagesize, int count)
        {
            return new JsonResult(new
            {
                EC = 0,
                EM = msg,
                DT = new
                {
                    Total = count,
                    TotalPage = (count % pagesize) > 0 ? count / pagesize + 1 : count / pagesize,
                    Current = page,
                    PageSize = pagesize,
                    list,
                },
            });
        }

        public JsonResult MsgReturn(int success, String msg, Object data)
        {
            return new JsonResult(new
            {
                EC = success,
                EM = msg,
                DT = data
            });
        }


    }
}

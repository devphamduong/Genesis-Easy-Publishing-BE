using Microsoft.AspNetCore.Mvc;
using System.Drawing.Printing;

namespace app.Service
{
    public class MsgService
    {
        public JsonResult MsgPagingReturn(String msg, Object ListStories, int page, int count)
        {
            return new JsonResult(new
            {
                EC = 0,
                EM = msg,
                DT = new
                {
                    TotalStories = count,
                    TotalPage = count / 10 + 1,
                    Current = page,
                    PageSize =10,
                    ListStories,
                },
            });
        }

        public JsonResult MsgReturn(String msg, Object data)
        {
            return new JsonResult(new
            {
                EC = 0,
                EM = msg,
                DT = data
            });
        }

    }
}

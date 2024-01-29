using Microsoft.AspNetCore.Mvc;
using System.Drawing.Printing;

namespace app.Service
{
    public class MsgService
    {
        public JsonResult MsgStoryReturn(String msg, Object ListStories, int page, int count)
        {
            return new JsonResult(new
            {
                EC = 0,
                EM = msg,
                DT = new
                {
                    StoriesNumber = count,
                    PageNumber = count / 20 + 1,
                    page,
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

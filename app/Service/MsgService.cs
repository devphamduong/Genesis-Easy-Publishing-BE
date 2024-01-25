using Microsoft.AspNetCore.Mvc;

namespace app.Service
{
    public class MsgService
    {
        public JsonResult MsgReturn(String msg,Object data)
        {
            return new JsonResult(new
            {
                EC = 0,
                EM = msg,
                DT = data,
            });
        }

    }
}

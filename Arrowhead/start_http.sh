/home/ArrowheadTest/HttpServer/shell2http -port 8888 -cgi -form \
/serviceRegistry "cat ui/serviceRegistry.html" \
/registerService "$PWD/ServiceRegistry/register_service.sh cat ui/registeredService.html" \
/getServices "cat ui/services.html" \
/orchestration "cat ui/orchestration.html" \
/load "cat $PWD/ui/load.js"


import ballerina/http;
import manageStudent;
import ballerina/io;

listener http:Listener listenerEndpoint = new(9090);

@http:ServiceConfig {
    basePath: "students"
}
service hello on listenerEndpoint {

    @http:ResourceConfig {
        methods: ["POST"],
        path : "submit"
    }
    resource function sayHello(http:Caller caller, http:Request request) {
        var data = request.getFormParams();
        if (data is map<string>)
        {
            manageStudent:addStudent(data);
            manageStudent:getStudents();
        }
        
        error? result = caller->respond("OK");
        if (result is error){
            io:println("Error in responding: ", result);
        }
    }
}
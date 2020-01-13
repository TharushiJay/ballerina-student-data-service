import ballerina/io;
import ballerinax/java.jdbc;

// JDBC Client for H2 database.
jdbc:Client testDB = new ({
    url: "jdbc:h2:file:./db_files/demodb",
    username: "test",
    password: "test"
});

type Person record {
    string nameWithInitial;
    string fullName;
    string gender;
};

type Student record {
    *Person;
    string address="";
};

type Father record {
    *Person;
};

public function main() {
}

public function createTable(){
    var ret = testDB->update("CREATE TABLE STUDENTS (NAMEWITHINITIAL VARCHAR(50), FULLNAME VARCHAR(100), GENDER VARCHAR(6), ADDRESS VARCHAR(50))");
    handleUpdate(ret, "Create STUDENTS table");

}

//Function to retrieve student data from the table
public function getStudents(){
    var selectRet = testDB->select("SELECT * FROM STUDENTS", Student);
    if (selectRet is table<Student>) {
        foreach var row in selectRet {
            io:println(row);
        }
    }
}

//Function to insert student data into the table
public function addStudent(map<string> data) {
    createTable();
    var nameWithInitials = data.get("nameWithInitials");
    var fullName = data.get("fullName");
    var gender = data.get("gender");
    var address = data.get("address");
    io:println(nameWithInitials);
    io:println(fullName);
    io:println(gender);
    io:println(address);
    var ret = testDB->update("INSERT INTO STUDENTS (NAMEWITHINITIAL, FULLNAME, GENDER, ADDRESS) VALUES (?, ?, ?, ?)", nameWithInitials, fullName, gender, address);
    handleUpdate(ret, "Insert data to STUDENTS table");
}

// Function to handle the return value of the `update` remote function.
function handleUpdate(jdbc:UpdateResult|error returned, string message) {
    if (returned is jdbc:UpdateResult) {
        io:println(message + " status: ", returned.updatedRowCount);
    } else {
        io:println(message + " failed: ", <string>returned.detail()?.message);
    }
}

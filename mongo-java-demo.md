


# Main.java


```java
import java.net.UnknownHostException;
import java.util.Arrays;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.MongoClient;
import com.mongodb.MongoCredential;
import com.mongodb.ServerAddress;

public class Main {

    public static void main(String[] args) throws UnknownHostException {
        MongoCredential credential = MongoCredential.createCredential("username", "database", "password".toCharArray());
        ServerAddress serverAddress = new ServerAddress("localhost", 27017);
        MongoClient mongoClient = new MongoClient(serverAddress, Arrays.asList(credential));
        
        DB db = mongoClient.getDB("xxx");
        DBCollection collection = db.getCollection("aaa");

        BasicDBObject doc = new BasicDBObject("name", "MongoDB")
                .append("type", "database")
                .append("count", 1)
                .append("info", new BasicDBObject("x", 203).append("y", 102));
        collection.insert(doc);

        System.out.println(collection.findOne());
    }
}

```
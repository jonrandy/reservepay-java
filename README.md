# reservepay-java

Typed Java clients to allow usage of the Reservepay APIs - [Merchant](https://developer.reservepay.com/api/merchants), [SDK](https://developer.reservepay.com/api/sdk)
, and [Terminal](https://developer.reservepay.com/api/terminals).

The clients (found in `src/main/java/com/reservepay/`) were generated using the [WebFunction CLI tool](https://github.com/webfunction-protocol/webfunction-cli).

Requires Java 17 or later.

## Usage

```xml
<dependency>
  <groupId>com.reservepay</groupId>
  <artifactId>reservepay</artifactId>
  <version>0.0.1</version>
</dependency>
```

Each API is in its own package (`com.reservepay.merchant`, `com.reservepay.sdk`, `com.reservepay.terminal`), each with a `Client` class. Each `Client` has a static `createNew` method which returns a fully configured client, ready to access the associated API.

```java
import com.reservepay.merchant.Client;
import org.webfunction.Options;

public class Example {
  public static void main(String[] args) {
    var client = Client.createNew(new Options().bearerAuth("MY_API_KEY"));

    var versions = client.availableApiVersions();

    System.out.println(String.join(", ", versions));
  }
}
```

As every API's class is called `Client`, refer to all but one of them by their full name if you use more than one in the same file:

```java
import com.reservepay.merchant.Client;

var merchant = Client.createNew(new Options().bearerAuth("MY_API_KEY"));
var terminal = com.reservepay.terminal.Client.createNew(new Options().bearerAuth("MY_API_KEY"));
```

The clients wrap [webfunction-java](https://github.com/webfunction-protocol/webfunction-java), which is installed as a dependency.

## Regenerating the clients

`./refresh_clients.sh` regenerates all three clients from the live APIs. It needs the `wfn` tool (set `WFN_PATH` if it is not in your `PATH`).

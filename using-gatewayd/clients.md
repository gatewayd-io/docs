---
last_modified_date: 2024-03-02 12:35:38
layout: default
title: Clients
description: Client object is a client that can connect to the database servers over TCP, UDP and Unix Domain Socket.
nav_order: 5
parent: Using GatewayD
---

# Clients

Client object is a client that can connect to the database servers over TCP, UDP and Unix Domain Socket. When GatewayD starts, a set of client objects are created that immediately connect to the users' database and are put into the [pool](/using-gatewayd/pools). Each client works independently, and a group of connections are connected to the same database server. The connection are gradually recycled.

## Pools and proxies

The clients work directly with the [pool](/using-gatewayd/pools) and the [proxy](/using-gatewayd/proxies) objects. When a new client connection is established, it is put into the pool it belong to. In turn, the pool itself belongs to a proxy object.

## Receive chunk size

Usually the incoming queries are small and can easily be sent to the database server for processing. However, the result of the query might be enormous. For the client to receive all the data at once, so it can send it to the database clients. For this, the client needs to read the kernel's buffer multiple times and concatenate the bytes to reconstruct the entire message. Internally, the client has a growing buffer, but for reading individual chunks, it needs a smaller buffer. The current default size of the chunk size is `8192` bytes.

The chunk size is adjustable, however, there is a trade-off. The smaller the number, the more it might take to read the entire message into the internal buffer. You can try to adjust the chunk size based on the response size from your database server.

{: .note }
> The response size can be observed by setting the (log) level of the [logger](/using-gatewayd/global-configuration/loggers) to `debug` and watching messages with the following format. The `length` key shows the response size in bytes.
>
> ```bash
> 2023-04-15T14:08:28+02:00 DBG Received data from database function=proxy.passthrough length=468 local=... remote=...
> ```

You can also use tools such as [fluentbit](https://fluentbit.io/) to stream and aggregate the logs to find the patterns.

## Send and receive deadlines

You have the option to set deadlines on send and receive calls to the database server. The client, in turn, sets the deadlines on the underlying connection object.

{: .warning }
> Setting send and receive deadlines are tricky, as the database server might kill the connection abruptly if it ceases to receive the data in whole. This also makes the connection unstable.

## Receive timeout

Since setting receive deadline kills the connection, the `receiveTimeout` property is introduced to stop the receive function from blocking the connection and waiting forever. The current value is zero, which means that it behaves like before, but one can set it to a duration string value.

## Dial timeout

The dial timeout is the amount of time the client should wait before giving up on dialing the database. The default value is `60s`. Setting it to `0s` disables the dial timeout.

## Retries and backoff

The first attempt to connect to the database server is made when the client is created, which happens instantly when GatewayD starts. However, if the first attempt fails, the client will retry the connection. The default number of retries is `3`, which means that the client will retry the connection three times before giving up. Setting it to `0` disables the retry mechanism. The client can also back off before retrying the connection. The backoff duration is set to `1s` by default and `0s` disables the backoff mechanism. The backoff multiplier is set to `2` by default and `0` disables the backoff. The backoff multiplier is applied to the backoff duration. The backoff duration is capped at `60s` by default and the max retry is capped at `10` by default. Setting `disableBackoffCaps` to `true` disables the backoff and retry caps.

{: .note }
> The first attempt to connect to the database server is counted as a retry, hence the three retries are actually four attempts (one instant attempt and three retry attempts), and the backoff duration is applied to the second attempt and so on.

The backoff duration is calculated by multiplying the backoff duration by the backoff multiplier raised to the power of the number of retries. For example, if the backoff duration is 1 second and the backoff multiplier is 2, the backoff duration will be 1 second, 2 seconds, 4 seconds, 8 seconds, etc. The backoff duration is capped at 1 minute and the backoff multiplier is capped at 10, so the backoff duration will be 1 minute after 6 retries. The backoff multiplier is capped at 10 to prevent the backoff duration from growing too quickly, unless the backoff caps are disabled. The following is the formula for calculating the backoff duration:

```text
backoff duration = backoff * (backoff multiplier ^ current retry number)
```

Considering the default values, the backoff duration will be calculated as follows:

```text
1 * 2 ^ 1 = 2 seconds
1 * 2 ^ 2 = 4 seconds
1 * 2 ^ 3 = 8 seconds
```

If the retries are set to `11`, the backoff duration from the fourth attempt will be calculated as follows, which is capped at 1 minute and 10 retries are made:

```text
1 * 2 ^ 4 = 16 seconds
1 * 2 ^ 5 = 32 seconds
1 * 2 ^ 6 = 1 minute
1 * 2 ^ 7 = 1 minute (capped)
1 * 2 ^ 8 = 1 minute (capped)
1 * 2 ^ 9 = 1 minute (capped)
1 * 2 ^ 10 = 1 minute (capped)
```

And if the backoff caps are disabled, the uncapped backoff duration for the fourth attempt will be calculated as follows:

```text
1 * 2 ^ 4 = 16 seconds
1 * 2 ^ 5 = 32 seconds
1 * 2 ^ 6 = 1 minute 4 seconds (uncapped)
1 * 2 ^ 7 = 2 minutes 8 seconds (uncapped)
1 * 2 ^ 8 = 4 minutes 16 seconds (uncapped)
1 * 2 ^ 9 = 8 minutes 32 seconds (uncapped)
1 * 2 ^ 10 = 17 minutes 4 seconds (uncapped)
1 * 2 ^ 11 = 34 minutes 8 seconds (uncapped)
```

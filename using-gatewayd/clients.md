---
last_modified_date: 2023-08-16 23:46:53 +0200
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

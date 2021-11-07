<p align="center"><div align="center" style="padding: 0 20%; font-size: 2rem;">

![](forbus.png)


**F**ederation **O**ver **R**edis **BUS**

</div></p>

# Forbus

FORbus is a simple, easy to deploy and easy to provision message and cache bus to allow sites on the same (or similar) frameworks to federate **BIDIRECTIONALLY**.
Most other Federation solutions are essentially just "RSS On Steroids", FORbus allows users on subscribing sites to interact with the publisher site almost as if they were members.

FORbus performs it's magic by granting ACL to a subscribing site to a corner of their Redis keyspace. This allows access to cached information, as well as access to content updates from the Publisher. Likewise, the publishing site gets similar visibility into a corner of the subscriber's Redis keyspace. An example of how
this would be useful is that when a Subscriber's user posts a response to a post, the publishing site can get information on that remote user from the subscriber's Redis cache. From this they can build whatever local model they need to assign ownership of the new post.

**Mission**

The goal here is to create an unopinionated transport layer which can handle the one-to-many nature of two servers cooperatively posting data to the same container. There are a few abstractions included to provide some basic structure to things - to give developers a notion of how to map what's in their apps to what FORbus does. For instance, the concept of an `Actor` ... this will usually be a `User` in the app, but it doesn't have to be. In fact, you could create a virtual Actor type for certain kinds of operations.

The downside here is that the developer will need to exert a little more effort in aligning what's in their apps to what FORbus needs to know about. Going back to the `Actor` example, the `User` model will need to have `:after` filters added to update the `Imprints` that are deposited in the Redis cache. Likewise callbacks and handlers will need to be written to handle moving data in and out of Forbus. But this only needs to be done once and its rarely more complex that parsing some JSON and then working on the result.

The advantage of making this unopinionated - the reward for having to do a little extra work to install plumbing - is that it will allow Forbus to not only work between two peer systems, but also two disparate systems. So if one system has User's and the other has Account's, Forbus will put the information needed to sync these two up on it's cache, and each side will interpret that cache to it's own needs.

**The Big Picture**

Stepping back from the **Mission**, what Forbus allows is for multiple content/community systems to connect over a constrained channel, in a publisher-to-many-subscribers relationship. Everyone in the chain can post, and upvote, and reply. The publisher can decide to sever any connection, as can any subscriber. What this means is community systems can collaborate to create their own self-regulated **Virtual Social Networks**. Networks where they and only they decide what the "guidelines" are.

## Core Abstactions

### Federation

When two servers connect they agree to provide each other with a corner of their Redis key space for pushing messages and commands. They also grant access to an ‘ecosystem’ corner of their Redis server where Imprints and inventory are kept.

The only real difference between a publisher and subscriber, is that when a subscriber posts to a shared channel, they send a message to the publisher. The publisher posts on their server and then broadcasts the new post to each subscriber.

Otherwise it’s the same - when a post from a Redis server comes in it gets posted via a Sidekiq job and the user’s Imprint is synced if needed.

**Ecosystem/Inventory Traded**

`forbus:site` - info about the federated site such as url, name, and so on

`forbus:imprints:channels:publisher-channel-id` - info about each subscribe-able channel (ex: _forbus:imprints:channels:123_)

`forbus:imprints:actors:publisher-actor-class-id` - info about each User or whatever they end up called on the platform (ex: _forbus:imprints:actors:user123_ or _forbus:imprints:actors:admin456_)

`forbus:markers:channel-id` - the last post-id in each channel, this is so a new or re-connecting server can figure out where to start asking for stuff or sync it’s state 

`forbus:rpc` - a place to deposit RPC responses with a 5-minute timeout

**Channels Traded**

`remotekey` is the random hash id that was assigned by the other party. This will be the channel (LIST) the subscriber monitors. Messages will have a `type` which can be one of:

**command** - make requests or send directives to the other party

**dm** - a new DM

### Actor

In Wingate parlance, this will either be a User or Fuser. Users create Imprints on local Redis, Fusers get loaded from the Imprints saved on the remote Redis.

All this part of the interface does is exchange information about the entities that can create posts so there’s a consistent view of this across platforms

### Channel

This is a means of conveying posts and channel commands (like registering a ‘like’ or get rid of temporary media storage once it’s been transferred). It works like the primary Federation Redis list, only here it can transport new posts. Each channel will have a Redis list `channelkey` which gets defined by the hosting server and then this key is shared to the remote for access.

**command** - make requests or send directives to the other party

**post** - a new Post

Subscribeable Channels are also Imprinted so that partner sites can get an inventory of channels they can request subscriptions to. What the actual model is doesn’t matter, the bus just knows about id’s and slugs and a json hash of attributes.

### Post

This is the content that gets moved between instances. What the model looks like doesn’t matter, what gets passed is a publisher-post-id, a publisher-channel-id, a publisher-actor-id, a federation-id and then a hash of actual post data. From that the subscribing side can do whatever needs to be done.

## RPC? Really?

Yup. You can't run a mechanism like this without one server being able to request specific data from another. The way it works is actually pretty simple:

1. Instance1 posts an RPC request on it's global command bus (a LIST assigned to a key on it's local Redis). The request has a SecureRandom request-id key added to the payload.
2. After posting, Instance1 then forks a thread to wait on the request-id key to appear on Instance2's rpc keyspace.
3. Instance2 is scanning that LIST and detects the new request and pops it off the LIST.
4. Instance2 then assembles the response and posts it on it's Redis under the 'rpc' key root, with the request-id token as the actual key.
5. Instance1 detects the request-key appearing on Instance2's Redis, collects the JSON response, and quits the thread.
6. Done.

## Cool. But, like, why Redis and not a normal API?

Redis provides a lot of functionality that would need to be built or layered on top of with an API. Not the least of which is pub/sub style lists and it's own ACL mechanism. By using Redis, we completely isolate both parties from security holes as there is no direct conversation between the two servers. Redis in effect acts as a buffer.

Next, Redis is fast and easy to deploy and scalable. Using Redis is also more fault tolerant. If a Redis instance goes down, it won't hang the other end of the connection - it'll just trap out and check back later. If you rely on API's over HTTP, you have to manage that connection and deal more directly with latency and protocol errors.

Lastly, using Redis in the manner done here makes the entire mechanism "fire and forget". Post a reply just puts a message on a bus, the publishing site will eventually read that new post, incorporate it into it's database, and then broadcast a "new post" command/payload to all subscribers. Doing the same with API's would be more complex.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'forbus'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install forbus

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/forbus. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/forbus/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Forbus project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/forbus/blob/master/CODE_OF_CONDUCT.md).

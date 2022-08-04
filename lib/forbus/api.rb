#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2021-10-25 15:25:00
# @Last Modified by:   msmiller
# @Last Modified time: 2021-10-25 15:51:22
#
# Copyright (c) Sharp Stone Codewerks / Mark S. Miller

# frozen_string_literal: true

=begin
The "api" functions are the way most developers will interact with FORBUS. These
methods wrap the underlying functionality in a REST-ful kind of API which will
be easier to understand.

They're all being put in one place for maintainability. It's simply easier to work
with the endpoints in one place. Plus any utility methods will be shared, so again
it's simply for convenience and all that good stuff.
=end

module Forbus

  class FORbus

    # SITE - get/set info on the owning site
    #
    # :get => site subscriber get the current site
    # :put => site owner sets site hash
    def site(method:, data: {})
      case method
      when :get
        get_site_hash
      when :put
        set_site_hash( data )
      else
        raise ForbusError, 'Illegal method'
      end
    end

    def channel(method:, channel_id:, data: {})
      case method
      when :get
        pull_channel_imprint_hash(channel_id)
      when :put
        push_channel_imprint_hash(channel_id, data)
      when :poke # tell subscriber that something has changed with the channel
      else
        raise ForbusError, 'Illegal method'
      end
    end

    def channel_marker(method:, data: {})
      case method
      when :get
      when :put
      when :poke # tell subscriber that there's new content
      else
        raise ForbusError, 'Illegal method'
      end
    end
  end
end


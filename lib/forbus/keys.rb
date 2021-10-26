#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2021-10-25 15:16:10
# @Last Modified by:   msmiller
# @Last Modified time: 2021-10-26 10:22:23
#
# Copyright (c) Sharp Stone Codewerks / Mark S. Miller

# frozen_string_literal: true

module Forbus

  ### Redis Key Root Definitions

  def self.ecosystem_key_root
    "forbus"
  end

  def self.imprints_key_root
    "#{ecosystem_key_root}:imprints"
  end

  def self.markers_key_root
    "#{ecosystem_key_root}:markers"
  end

  def self.rpc_key_root
    "#{ecosystem_key_root}:rpc"
  end

  ### Redis Key Definitions

  def self.site_key(site_id=1)
    "#{ecosystem_key_root}:site:#{site_id}"
  end

  def self.rpc_key(token)
    "#{rpc_key_root}:#{token}"
  end

  def self.channel_imprint_key(channel_id)
    "#{imprints_key_root}:channels:#{channel_id}"
  end

  def self.actor_imprint_key(actor_id)
    "#{imprints_key_root}:actors:#{actor_id}"
  end

  def self.marker_key(channel_id)
    "#{markers_key_root}:#{channel_id}"
  end

  def self.rpc_key(response_id)
    "#{rpc_key_root}:#{response_id}"
  end

end

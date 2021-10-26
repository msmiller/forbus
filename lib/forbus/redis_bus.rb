#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2021-10-25 15:25:00
# @Last Modified by:   msmiller
# @Last Modified time: 2021-10-26 10:39:05
#
# Copyright (c) Sharp Stone Codewerks / Mark S. Miller

# frozen_string_literal: true

module Forbus

  def self.create_random_user_pass
    { username: SecureRandom.alphanumeric(20), password: SecureRandom.alphanumeric(20) }
  end

  class FORbus

    def set_bus_acl(user, pass, channel_id)
    end

  end

end

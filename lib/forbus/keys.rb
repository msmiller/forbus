# frozen_string_literal: true

module Forbus

  ### Redis Key Root Definitions

  def self.ecosystem_key_root
    "forbus"
  end

  def self.site_key_root
    "#{ecosystem_key_root}:site:1"
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

  def self.rpc_key(token)
    "#{rpc_key_root}:#{token}"
  end

end

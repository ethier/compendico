module ApplicationCable
  class DigestChannel < ApplicationCable::Channel
    def subscribed
      stream_from "digest_#{params[:organization_id]}"
    end

    def receive(data)
      ActionCable.server.broadcast("digest_#{params[:organization_id]}", data)
    end
  end
end

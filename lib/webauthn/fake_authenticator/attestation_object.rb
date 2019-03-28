# frozen_string_literal: true

require "cbor"
require "webauthn/fake_authenticator/authenticator_data"

module WebAuthn
  class FakeAuthenticator
    class AttestationObject
      def initialize(
        client_data_hash:,
        rp_id_hash:,
        credential_id:,
        credential_key:,
        user_present: true,
        user_verified: false
      )
        @client_data_hash = client_data_hash
        @rp_id_hash = rp_id_hash
        @credential_id = credential_id
        @credential_key = credential_key
        @user_present = user_present
        @user_verified = user_verified
      end

      def serialize
        CBOR.encode(
          "fmt" => "none",
          "attStmt" => {},
          "authData" => authenticator_data.serialize
        )
      end

      private

      attr_reader :client_data_hash, :rp_id_hash, :credential_id, :credential_key, :user_present, :user_verified

      def authenticator_data
        @authenticator_data ||= AuthenticatorData.new(
          rp_id_hash: rp_id_hash,
          credential: { id: credential_id, public_key: credential_key.public_key },
          user_present: user_present,
          user_verified: user_verified
        )
      end
    end
  end
end
# frozen_string_literal: true

class FireSportStatistics::Publishing
  include ActiveModel::Model
  attr_accessor :competition

  validates :competition, presence: true

  def save
    return false unless valid?

    cookies = login

    conn.post('/api/import_requests', { 'import_request[compressed_data]': export_data }.to_query,
              'Cookie' => cookies)
  rescue OpenSSL::SSL::SSLError, Errno::ECONNREFUSED, SocketError, Net::ReadTimeout => e
    errors.add(:base, e.message)
    false
  end

  def export_data
    Exports::FullDump.new(competition).to_export_data
  end

  def login
    response = conn.post('/api/api_users', { 'api_user[name]': competition.name }.to_query)
    raise 'Login failed' unless response.code == '200'

    response.get_fields('set-cookie').map { |cookie| cookie.split('; ')[0] }.join('; ')
  end

  def conn
    @conn ||= begin
      http = Net::HTTP.new('feuerwehrsport-statistik.de', 443)
      http.use_ssl = true
      http
    end
  end
end

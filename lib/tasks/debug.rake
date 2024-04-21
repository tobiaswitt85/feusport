# frozen_string_literal: true

namespace :debug do
  desc 'notify about failed delayed jobs'
  task failed_delayed_jobs: :environment do
    # delete failed delayed jobs, when records not found
    Delayed::Job.where.not(failed_at: nil).where("last_error LIKE 'ActiveRecord::RecordNotFound%'").find_each do |job|
      job.payload_object
    rescue Delayed::DeserializationError
      job.delete
    end

    failed_jobs = Delayed::Job.where.not(failed_at: nil)
    if failed_jobs.present?
      failed_ids = failed_jobs.map(&:id).sort.to_json
      current_file = Rails.root.join("tmp/failed_delayed_jobs-#{Date.current}.json")

      next if File.file?(current_file) && File.read(current_file) == failed_ids

      File.write(current_file, failed_ids)

      puts "Some delayed jobs failed on #{`hostname`}"
      p failed_jobs
    end
  end
end

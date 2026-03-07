module Appointments
    class Create
      Result = Struct.new(:success?, :appointment, :error)
  
      def initialize(starts_at:, ends_at:)
        @starts_at = starts_at
        @ends_at = ends_at
      end
  
      def call
        return overlap_failure if overlap_exists?
  
        appointment = Appointment.create!(
          starts_at: starts_at,
          ends_at: ends_at
        )
  
        Result.new(true, appointment, nil)
      end
  
      private
  
      attr_reader :starts_at, :ends_at
  
      def overlap_exists?
        Appointment
          .where("starts_at < ? AND ends_at > ?", ends_at, starts_at)
          .exists?
      end
  
      def overlap_failure
        Result.new(false, nil, "Appointment overlaps with existing booking")
      end
    end
  end
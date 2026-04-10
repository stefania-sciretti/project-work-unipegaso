package com.clinica.repository

import com.clinica.domain.Appointment
import com.clinica.domain.AppointmentStatus
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.time.LocalDateTime

@Repository
interface AppointmentRepository : JpaRepository<Appointment, Long> {
    fun findByPatientId(patientId: Long): List<Appointment>
    fun findByDoctorId(doctorId: Long): List<Appointment>
    fun findByStatus(status: AppointmentStatus): List<Appointment>
    fun findByPatientIdAndStatus(patientId: Long, status: AppointmentStatus): List<Appointment>
    fun findByDoctorIdAndScheduledAtBetween(
        doctorId: Long, from: LocalDateTime, to: LocalDateTime
    ): List<Appointment>
}

package com.clinica.repository

import com.clinica.domain.Report
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface ReportRepository : JpaRepository<Report, Long> {
    fun findByAppointmentId(appointmentId: Long): Optional<Report>
    fun existsByAppointmentId(appointmentId: Long): Boolean
}

package com.clinica.application.service

import com.clinica.application.domain.Appointment
import com.clinica.application.domain.AppointmentStatus
import com.clinica.doors.outbound.database.dao.AppointmentDao
import com.clinica.doors.outbound.database.dao.DoctorDao
import com.clinica.doors.outbound.database.dao.PatientDao
import com.clinica.dto.AppointmentRequest
import com.clinica.dto.AppointmentResponse
import com.clinica.dto.AppointmentStatusRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDateTime

@Service
@Transactional
class AppointmentService(
    private val appointmentDao: AppointmentDao,
    private val patientDao: PatientDao,
    private val doctorDao: DoctorDao,
) {

    @Transactional(readOnly = true)
    fun findAll(
        patientId: Long?,
        doctorId: Long?,
        status: String?
    ): List<AppointmentResponse> =
        appointmentDao.findAll(patientId, doctorId, status)
            .map { it.toResponse() }
    @Transactional(readOnly = true)
    fun findById(id: Long): AppointmentResponse =
        appointmentDao.findById(id).orThrow("Appointment not found with id: $id").toResponse()

    fun create(request: AppointmentRequest): AppointmentResponse {
        val patient = patientDao.findById(request.patientId)
            .orThrow("Patient not found with id: ${request.patientId}")

        val doctor = doctorDao.findById(request.doctorId)
            .orThrow("Doctor not found with id: ${request.doctorId}")

        val appointment = Appointment(
            id = 0L,
            patient = patient,
            doctor = doctor,
            scheduledAt = request.scheduledAt,
            visitType = request.visitType,
            status = AppointmentStatus.BOOKED,
            notes = request.notes,
            updatedAt = LocalDateTime.now(),
            report = null
        )

        return appointmentDao.save(appointment).toResponse()
    }

    fun updateStatus(id: Long, request: AppointmentStatusRequest): AppointmentResponse {
        val appointment = appointmentDao.findById(id)
            .orThrow("Appointment not found with id: $id")
        val updated = appointment.copy(
            status = AppointmentStatus.parse(request.status),
            updatedAt = LocalDateTime.now()
        )
        return appointmentDao.save(updated).toResponse()
    }

    fun delete(id: Long) {
        appointmentDao.findById(id).orThrow("Appointment not found with id: $id")
        appointmentDao.deleteById(id)
    }

    private fun Appointment.toResponse(): AppointmentResponse =
        AppointmentResponse(
            id = this.id,
            patientId = this.patient.id,
            patientFullName = this.patient.fullName,
            doctorId = this.doctor.id,
            doctorFullName = this.doctor.fullName,
            doctorSpecialization = this.doctor.specialization,
            scheduledAt = this.scheduledAt,
            visitType = this.visitType,
            status = this.status.name,
            notes = this.notes,
            hasReport = this.report != null,
            createdAt = this.updatedAt
        )
}
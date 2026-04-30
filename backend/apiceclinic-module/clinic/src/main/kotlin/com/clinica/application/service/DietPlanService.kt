package com.clinica.application.service

import com.clinica.application.domain.DietPlan
import com.clinica.doors.outbound.database.dao.DietPlanDao
import com.clinica.doors.outbound.database.dao.PatientDao
import com.clinica.doors.outbound.database.dao.StaffDao
import com.clinica.dto.DietPlanRequest
import com.clinica.dto.DietPlanResponse
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDateTime

@Service
@Transactional
class DietPlanService(
    private val dietPlanDao: DietPlanDao,
    private val patientDao: PatientDao,
    private val staffDao: StaffDao
)  {

    @Transactional(readOnly = true)
    fun findAll(clientId: Long?): List<DietPlanResponse> =
        dietPlanDao.findAll(clientId)
            .map { it.toResponse() }

    @Transactional(readOnly = true)
    fun findById(id: Long): DietPlanResponse =
        dietPlanDao.findById(id).orThrow("Diet plan not found with id: $id").toResponse()

    fun create(request: DietPlanRequest): DietPlanResponse {
        val client = patientDao.findById(request.clientId)
            .orThrow("Client (patient) not found with id: ${request.clientId}")

        val trainer = staffDao.findById(request.trainerId)
            .orThrow("Trainer (staff) not found with id: ${request.trainerId}")

        val now = LocalDateTime.now()

        val dietPlan = DietPlan(
            id = 0L,
            client = client,
            trainer = trainer,
            title = request.title,
            description = request.description,
            calories = request.calories,
            durationWeeks = request.durationWeeks,
            active = request.active,
            createdAt = now,
            updatedAt = now
        )

        return dietPlanDao.save(dietPlan).toResponse()
    }

    fun update(id: Long, request: DietPlanRequest): DietPlanResponse {
        val existing = dietPlanDao.findById(id)
            .orThrow("Diet plan not found with id: $id")

        val client = patientDao.findById(request.clientId)
            .orThrow("Client (patient) not found with id: ${request.clientId}")

        val trainer = staffDao.findById(request.trainerId)
            .orThrow("Trainer (staff) not found with id: ${request.trainerId}")

        val updated = existing.copy(
            client = client,
            trainer = trainer,
            title = request.title,
            description = request.description,
            calories = request.calories,
            durationWeeks = request.durationWeeks,
            active = request.active,
            updatedAt = LocalDateTime.now()
        )

        return dietPlanDao.save(updated).toResponse()
    }

    fun delete(id: Long) {
        dietPlanDao.findById(id).orThrow("Diet plan not found with id: $id")
        dietPlanDao.deleteById(id)
    }

    private fun DietPlan.toResponse(): DietPlanResponse =
        DietPlanResponse(
            id = this.id,
            clientId = this.client.id,
            trainerId = this.trainer.id,
            clientFirstName = this.client.firstName,
            clientLastName = this.client.lastName,
            trainerFirstName = this.trainer.firstName,
            trainerLastName = this.trainer.lastName,
            title = this.title,
            description = this.description,
            calories = this.calories,
            durationWeeks = this.durationWeeks,
            active = this.active,
            createdAt = this.createdAt,
            updatedAt = this.updatedAt
        )
}
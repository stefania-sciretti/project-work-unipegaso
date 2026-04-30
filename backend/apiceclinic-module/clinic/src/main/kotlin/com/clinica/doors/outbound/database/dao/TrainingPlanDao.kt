package com.clinica.doors.outbound.database.dao

import com.clinica.application.domain.TrainingPlan
import com.clinica.doors.outbound.database.entities.PatientEntity
import com.clinica.doors.outbound.database.entities.StaffEntity
import com.clinica.doors.outbound.database.mappers.toDomain
import com.clinica.doors.outbound.database.mappers.toEntity
import com.clinica.doors.outbound.database.repositories.PatientRepository
import com.clinica.doors.outbound.database.repositories.StaffRepository
import com.clinica.doors.outbound.database.repositories.TrainingPlanRepository
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional

@Component
class TrainingPlanDao(
    private val trainingPlanRepository: TrainingPlanRepository,
    private val patientRepository: PatientRepository,
    private val staffRepository: StaffRepository
) {

    @Transactional(readOnly = true)
    fun findAll(clientId: Long?): List<TrainingPlan> =
        if (clientId == null) trainingPlanRepository.findAll().map { it.toDomain() }
        else trainingPlanRepository.findByClientEntityId(clientId).map { it.toDomain() }

    @Transactional(readOnly = true)
    fun findById(id: Long): TrainingPlan? =
        trainingPlanRepository.findById(id).orElse(null)?.toDomain()

    @Transactional(readOnly = true)
    fun existsById(id: Long): Boolean =
        trainingPlanRepository.existsById(id)

    @Transactional
    fun save(plan: TrainingPlan): TrainingPlan {
        val clientEntity: PatientEntity = patientRepository.findById(plan.client.id)
            .orElseThrow { IllegalArgumentException("Client not found with id: ${plan.client.id}") }
        val staffEntity: StaffEntity = staffRepository.findById(plan.trainer.id)
            .orElseThrow { IllegalArgumentException("Staff not found with id: ${plan.trainer.id}") }

        val existing = if (plan.id != 0L)
            trainingPlanRepository.findById(plan.id).orElse(null) else null

        val entityToSave = plan.toEntity(
            clientEntityProvider = { clientEntity },
            staffEntityProvider = { staffEntity },
            existingEntity = existing
        )
        return trainingPlanRepository.save(entityToSave).toDomain()
    }

    @Transactional
    fun deleteById(id: Long) =
        trainingPlanRepository.deleteById(id)
}

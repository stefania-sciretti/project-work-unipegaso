package com.clinica.doors.outbound.database.mappers

import com.clinica.application.domain.TrainingPlan
import com.clinica.doors.outbound.database.entities.PatientEntity
import com.clinica.doors.outbound.database.entities.StaffEntity
import com.clinica.doors.outbound.database.entities.TrainingPlanEntity

fun TrainingPlanEntity.toDomain(): TrainingPlan =
    TrainingPlan(
        id = this.id,
        client = this.clientEntity.toDomain(),
        trainer = this.staff.toDomain(),
        title = this.title,
        description = this.description,
        weeks = this.weeks,
        sessionsPerWeek = this.sessionsPerWeek,
        active = this.active,
        createdAt = this.createdAt
    )

fun TrainingPlan.toEntity(
    clientEntityProvider: () -> PatientEntity,
    staffEntityProvider: () -> StaffEntity,
    existingEntity: TrainingPlanEntity? = null
): TrainingPlanEntity {
    existingEntity?.let {
        it.clientEntity = clientEntityProvider()
        it.staff = staffEntityProvider()
        it.title = this.title
        it.description = this.description
        it.weeks = this.weeks
        it.sessionsPerWeek = this.sessionsPerWeek
        it.active = this.active
        return it
    }
    return TrainingPlanEntity(
        id = this.id,
        clientEntity = clientEntityProvider(),
        staff = staffEntityProvider(),
        title = this.title,
        description = this.description,
        weeks = this.weeks,
        sessionsPerWeek = this.sessionsPerWeek,
        active = this.active
    )
}

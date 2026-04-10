package com.clinica.repository

import com.clinica.domain.DietPlan
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface DietPlanRepository : JpaRepository<DietPlan, Long> {
    fun findByClientId(clientId: Long): List<DietPlan>
    fun findByClientIdAndActiveTrue(clientId: Long): List<DietPlan>
    fun countByActiveTrue(): Long
}

package com.clinica

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.autoconfigure.domain.EntityScan
import org.springframework.boot.runApplication
import org.springframework.data.jpa.repository.config.EnableJpaRepositories

@SpringBootApplication
@EntityScan(basePackages = ["com.clinica.doors.outbound.database.entities"])
@EnableJpaRepositories(basePackages = ["com.clinica.doors.outbound.database.repositories"])
class ClinicaApplication

fun main(args: Array<String>) {
    runApplication<ClinicaApplication>(*args)
}

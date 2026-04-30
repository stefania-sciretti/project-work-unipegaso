package com.clinica.application.service

fun <T> T?.orThrow(message: String): T = this ?: throw NoSuchElementException(message)

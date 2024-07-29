//  =============================================================
//  File: BijectiveDictionary+Sendable.swift
//  Project: BijectiveDictionary
//  -------------------------------------------------------------
//  Created by Jacob Gelman on 07/29/2024
//  Copyright © 2024 Jacob Gelman. All rights reserved.
//  =============================================================

extension BijectiveDictionary: @unchecked Sendable
where Left: Sendable, Right: Sendable {}

//
//  Modules.swift
//  DependencyPlugin
//
//  Created by 정현우 on 8/21/24.
//

import Foundation
import ProjectDescription

public enum ModulePath {
	case feature(Feature)
	case domain(Domain)
	case core(Core)
	case shared(Shared)
}

// MARK: - App Module
public extension ModulePath {
	enum App: String, CaseIterable {
		case IOS
		
		public static let name: String = "App"
	}
}

// MARK: - Feature Module
public extension ModulePath {
	enum Feature: String, CaseIterable {
		case Friend
		case Category
		case Home
        case Moim
        case Onboarding
		case Calendar
        case PlaceSearch
		
		public static let name: String = "Feature"
	}
}

// MARK: - Domain Module

public extension ModulePath {
	enum Domain: String, CaseIterable {
		case Friend
		case Category
		case Schedule
        case Moim
        case Auth
        case PlaceSearch
		
		public static let name: String = "Domain"
	}
}

// MARK: - Core Module

public extension ModulePath {
	enum Core: String, CaseIterable {
		case Network
		
		public static let name: String = "Core"
	}
}

// MARK: - Shared Module

public extension ModulePath {
	enum Shared: String, CaseIterable {
		case Util
		case DesignSystem
		case ThirdPartyLib
		
		public static let name: String = "Shared"
	}
}

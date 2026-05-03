class_name SerDeUtil

static func serialize_vector3(vec: Vector3) -> Dictionary:
	return {
		"x": vec.x,
		"y": vec.y,
		"z": vec.z,
	}

static func deserialize_vector3(data: Dictionary) -> Vector3:
	return Vector3(
		data["x"],
		data["y"],
		data["z"],
	)

static func serialize_transform3d(transform: Transform3D) -> Dictionary:
	return {
		"origin": serialize_vector3(transform.origin),
		"basis": {
			"x": serialize_vector3(transform.basis.x),
			"y": serialize_vector3(transform.basis.y),
			"z": serialize_vector3(transform.basis.z),
		},
	}

static func deserialize_transform3d(data: Dictionary) -> Transform3D:
	return Transform3D(
		Basis(
			deserialize_vector3(data["basis"]["x"]),
			deserialize_vector3(data["basis"]["y"]),
			deserialize_vector3(data["basis"]["z"]),
		),
		deserialize_vector3(data["origin"])
	)
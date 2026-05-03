class_name SerDeUtil

static func assert_keys(data: Dictionary, keys: Array):
	for key in keys:
		if not data.has(key):
			push_error("Missing key '%s' in data: %s" % [key, str(data)])

static func serialize_vector3(vec: Vector3) -> Dictionary:
	return {
		"x": vec.x,
		"y": vec.y,
		"z": vec.z,
	}

static func deserialize_vector3(data: Dictionary) -> Vector3:
	assert_keys(data, ["x", "y", "z"])

	return Vector3(
		data["x"],
		data["y"],
		data["z"],
	)

static func serialize_basis(basis: Basis) -> Dictionary:
	return {
		"x": serialize_vector3(basis.x),
		"y": serialize_vector3(basis.y),
		"z": serialize_vector3(basis.z),
	}

static func deserialize_basis(data: Dictionary) -> Basis:
	assert_keys(data, ["x", "y", "z"])

	return Basis(
		deserialize_vector3(data["x"]),
		deserialize_vector3(data["y"]),
		deserialize_vector3(data["z"]),
	)

static func serialize_transform3d(transform: Transform3D) -> Dictionary:
	return {
		"origin": serialize_vector3(transform.origin),
		"basis": serialize_basis(transform.basis),
	}

static func deserialize_transform3d(data: Dictionary) -> Transform3D:
	assert_keys(data, ["origin", "basis"])

	return Transform3D(
		deserialize_basis(data["basis"]),
		deserialize_vector3(data["origin"])
	)
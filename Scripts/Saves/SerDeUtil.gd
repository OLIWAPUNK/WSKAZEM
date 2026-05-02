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
		"origin": {
			"x": transform.origin.x,
			"y": transform.origin.y,
			"z": transform.origin.z,
		},
		"basis": {
			"x": {
				"x": transform.basis.x.x,
				"y": transform.basis.x.y,
				"z": transform.basis.x.z,
			},
			"y": {
				"x": transform.basis.y.x,
				"y": transform.basis.y.y,
				"z": transform.basis.y.z,
			},
			"z": {
				"x": transform.basis.z.x,
				"y": transform.basis.z.y,
				"z": transform.basis.z.z,
			},
		},
	}

static func deserialize_transform3d(data: Dictionary) -> Transform3D:
	return Transform3D(
		Basis(
			Vector3(
				data["basis"]["x"]["x"],
				data["basis"]["x"]["y"],
				data["basis"]["x"]["z"],
			),
			Vector3(
				data["basis"]["y"]["x"],
				data["basis"]["y"]["y"],
				data["basis"]["y"]["z"],
			),
			Vector3(
				data["basis"]["z"]["x"],
				data["basis"]["z"]["y"],
				data["basis"]["z"]["z"],
			),
		),
		Vector3(
			data["origin"]["x"],
			data["origin"]["y"],
			data["origin"]["z"],
		)
	)
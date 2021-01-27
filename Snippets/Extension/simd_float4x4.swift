//
//  simd_float4x4.swift
//  Snippets
//
//  Created by 温蟾圆 on 2021/1/27.
//

import SceneKit
import simd

extension simd_float4x4 {
    /// 返回欧拉角
    var eulerAngles: simd_float3 {
        simd_float3(
            x: asin(-self[2][1]),
            y: atan2(self[2][0], self[2][2]),
            z: atan2(self[0][1], self[1][1])
        )
    }
}

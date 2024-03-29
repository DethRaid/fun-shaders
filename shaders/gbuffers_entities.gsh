#version 450 compatibility

#define FUR_LENGTH 0.005
#define NUM_LAYERS 25

const float distance_between_layers = FUR_LENGTH / NUM_LAYERS;

layout(triangles) in;
layout(triangle_strip, max_vertices = NUM_LAYERS * 3) out;

uniform vec3 cameraPosition;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;
uniform mat4 gbufferModelViewInverse; 
uniform mat4 gbufferProjectionInverse;

in VS_OUT {
    vec3 normal;
    vec2 texcoord;
} gs_in[];

out GS_OUT {
    vec3 normal;
    vec2 texcoord;
    float normalized_offset;
} gs_out;

/// Emits the original primitive
void emit_input_mesh() {
    for(int i = 0; i < gl_in.length(); i++) {
        gs_out.normal = gs_in[i].normal;
        gs_out.texcoord = gs_in[i].texcoord;
        gs_out.normalized_offset = 1;

        gl_Position = gl_in[i].gl_Position;
        EmitVertex();
    }

    EndPrimitive();
}

/// Emits a fur layer that's offset along the mesh's normal
void emit_fur_layer(in float offset) {
    for(int i = 0; i < gl_in.length(); i++) {
        gs_out.normal = gs_in[i].normal;
        gs_out.texcoord = gs_in[i].texcoord;
        gs_out.normalized_offset = offset / FUR_LENGTH;

        // Okay so we have to send the vertex to us in clip space, then untransform it into world space, because the 
        // shaders mod is really fucking stupid and doesn't know what a view matrix is so there's actually no way I can
        // do something sane, like transforming into world space in the vertex shader, then transforming into clip
        // space after I modify the vertex position here
        
        vec4 world_pos = gl_in[i].gl_Position;
        world_pos = gbufferModelViewInverse * gbufferProjectionInverse * world_pos;

        const vec3 world_space_normal = mat3(gbufferModelViewInverse) * gs_in[i].normal;

        // Bring further away layers closer so we don't get so many visual artifacts
        const vec3 fur_layer_offset = world_space_normal * sqrt(FUR_LENGTH - offset);
        
        vec4 fur_layer_position = vec4(fur_layer_offset, 0.0) + world_pos;

        // yeah great let's multiply another matrix so everyone can complain that geometry shaders are slow
        gl_Position = gbufferProjection * gbufferModelView * fur_layer_position;

        EmitVertex();
    }

    EndPrimitive();
}

void main() {
    emit_input_mesh();

    for(int i = 0; i < NUM_LAYERS; i++) {
        const float layer_offset = i * distance_between_layers;

        emit_fur_layer(layer_offset);
    }

    EndPrimitive();
}
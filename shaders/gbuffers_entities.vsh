#version 450 compatibility

/*! \file gbuffers_entities.vsh
 * 
 * \brief Vertex shader for entities. Emits vertex positions and normals in world space
 */
 
 // TODO: Figure out the vertex attribute locations

out VS_OUT {
    vec3 normal;
    vec2 texcoord;
} vs_out;

void main() {
    vs_out.normal = gl_NormalMatrix * gl_Normal.xyz;
    vs_out.texcoord = gl_MultiTexCoord0.xy;

    gl_Position = ftransform();
}
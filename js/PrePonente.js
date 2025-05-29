document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('ponenteForm');
    const successAlert = document.getElementById('successAlert');
    const errorAlert = document.getElementById('errorAlert');
    const loadingIndicator = document.getElementById('loadingIndicator');
    const submitButton = form.querySelector('button[type="submit"]');

    // Mostrar alertas
    function showAlert(alertElement, message) {
        alertElement.textContent = message;
        alertElement.style.display = 'block';
        setTimeout(() => {
            alertElement.style.display = 'none';
        }, 5000);
    }

    // Validar formulario
    function validateForm() {
        // Validar checkboxes
        const checkboxes = form.querySelectorAll('input[name="tipo_participacion[]"]:checked');
        if (checkboxes.length === 0) {
            showAlert(errorAlert, 'Debe seleccionar al menos un tipo de participación');
            return false;
        }

        // Validar presentación
        const presentacion = form.elements['presentacion'].value;
        if (presentacion.length < 100) {
            showAlert(errorAlert, 'La presentación debe tener al menos 100 caracteres');
            return false;
        }

        // Validar archivos
        const cvFile = form.elements['cv_url'].files[0];
        const fotoFile = form.elements['foto_url'].files[0];
        
        if (cvFile && cvFile.size > 5 * 1024 * 1024) {
            showAlert(errorAlert, 'El CV no debe exceder 5MB');
            return false;
        }
        
        if (fotoFile && fotoFile.size > 2 * 1024 * 1024) {
            showAlert(errorAlert, 'La foto no debe exceder 2MB');
            return false;
        }

        return true;
    }

    // Manejar el envío del formulario
    async function handleSubmit(e) {
        e.preventDefault();

        if (!validateForm()) return;

        try {
            loadingIndicator.style.display = 'block';
            submitButton.disabled = true;

            const formData = new FormData(form);
            
            const response = await fetch(form.action, {
                method: 'POST',
                body: formData
            });

            // Verificar el tipo de contenido de la respuesta
            const contentType = response.headers.get('content-type');
            
            if (contentType && contentType.includes('application/json')) {
                const result = await response.json();
                
                if (!response.ok) {
                    throw new Error(result.message || `Error del servidor (${response.status})`);
                }

                if (result.success) {
                    showAlert(successAlert, result.message);
                    
                    // Redirección si está especificada
                    if (result.redirectUrl) {
                        setTimeout(() => {
                            window.location.href = result.redirectUrl;
                        }, 2000);
                    }
                } else {
                    throw new Error(result.message || 'Error al procesar la solicitud');
                }
            } else {
                // Fallback para respuestas no JSON (compatibilidad con versiones anteriores)
                const text = await response.text();
                const tempDiv = document.createElement('div');
                tempDiv.innerHTML = text;
                const scripts = tempDiv.getElementsByTagName('script');
                
                if (scripts.length > 0) {
                    // Ejecutar el script de respuesta
                    eval(scripts[0].innerHTML);
                } else {
                    throw new Error('La respuesta del servidor no fue válida');
                }
            }
        } catch (error) {
            console.error('Error completo:', error);
            showAlert(errorAlert, error.message || 'Error al enviar el formulario');
            
            // Mostrar detalles técnicos en consola
            if (error.response) {
                console.error('Detalles de la respuesta:', await error.response.text());
            }
        } finally {
            loadingIndicator.style.display = 'none';
            submitButton.disabled = false;
        }
    }

    // Configurar validaciones en tiempo real
    function setupValidations() {
        // Validación de presentación
        form.elements['presentacion'].addEventListener('input', function() {
            this.setCustomValidity(this.value.length < 100 ? 
                'La presentación debe tener al menos 100 caracteres' : '');
        });

        // Validación de archivos
        form.elements['cv_url'].addEventListener('change', function() {
            if (this.files[0]?.size > 5 * 1024 * 1024) {
                this.setCustomValidity('El CV no debe exceder 5MB');
                showAlert(errorAlert, 'El CV no debe exceder 5MB');
            } else {
                this.setCustomValidity('');
            }
        });

        form.elements['foto_url'].addEventListener('change', function() {
            if (this.files[0]?.size > 2 * 1024 * 1024) {
                this.setCustomValidity('La foto no debe exceder 2MB');
                showAlert(errorAlert, 'La foto no debe exceder 2MB');
            } else {
                this.setCustomValidity('');
            }
        });

        // Validación de checkboxes
        const checkboxes = form.querySelectorAll('input[name="tipo_participacion[]"]');
        checkboxes.forEach(checkbox => {
            checkbox.addEventListener('change', () => {
                const checked = form.querySelectorAll('input[name="tipo_participacion[]"]:checked');
                if (checked.length === 0) {
                    showAlert(errorAlert, 'Seleccione al menos un tipo de participación');
                }
            });
        });
    }

    // Inicializar
    form.addEventListener('submit', handleSubmit);
    setupValidations();
});
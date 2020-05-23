<template>
	<div class="messages">
	    <vue-good-table
        :columns="columns"
        :rows="messages"
        theme="black-rhino"
        :pagination-options="{
            enabled: true,
            mode: 'records',
            perPage: 10,
            position: 'bottom',
            perPageDropdown: [10, 25, 50, 100],
            dropdownAllowAll: false,
            setCurrentPage: 1,
            nextLabel: 'Siguiente',
            prevLabel: 'Anterior',
            rowsPerPageLabel: 'Registros por pagina',
            ofLabel: 'of',
            pageLabel: 'page', // for 'pages' mode
            allLabel: 'All',
        }" />
	</div>
</template>

<script>
import 'vue-good-table/dist/vue-good-table.css'
import { VueGoodTable } from 'vue-good-table/src';

export default {
	name: 'tablu',
    props: ['messages'],
    components: {
        VueGoodTable,
    },
	data: function () {
		return {
			columns: [
        {
          label: 'ID',
          field: '_id',
        },
        {
          label: 'Movimiento',
          field: 'mov',
          tdClass:'text-center',
        },
        {
          label: 'Fecha de registro',
          field: 'RegisterDate',
          type: 'date',
          dateInputFormat: 'yyyy-MM-dd HH:mm:ss',
          dateOutputFormat: 'yyyy-MM-dd HH:mm:ss'
        },
        {
            label: 'Duración',
            field: 'Duration',
        },
        {
            label: 'Lugar', 
            field: 'place',
        }
      ]/*/,
      rows:['messages']*/

		}
	}
}


</script>

<style lang="scss" scoped>
.text-center{
    color:#36f
}
</style>

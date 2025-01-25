import { component$ } from '@builder.io/qwik';
import type { DocumentHead } from '@builder.io/qwik-city';
import Call from '~/components/call/Call';
import Add from '~/components/add/Add';

export default component$(() => {
  return (
    <>
      <Add />
      <Call />
    </>
  );
});

export const head: DocumentHead = {
  title: 'SMDC Portal',
  meta: [
    {
      name: 'description',
      content: 'SMDC Technologies',
    },
  ],
};
